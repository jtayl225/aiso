#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 21 11:57:04 2025

@author: jesse
"""

####################
# imports
####################

# standard
import os

import asyncio
from enum import Enum
from typing import List, Optional

# third-party
from fastapi import FastAPI, Depends, HTTPException, JSONResponse, Request
from pydantic import BaseModel, Field
from openai import OpenAI
from supabase import create_client, Client

# local
from classes import (
    SearchResult, SearchResults, SearchTarget,
    SearchPromptResult, LLM, SearchRequest, SearchResponse,
    RunRequest
)
from functions import (
    find_search_target, sample_temperature, 
    get_openai_client, get_supabase_client, fetch_data
)

####################
# clients
####################

app = FastAPI()
# client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

####################
# helper functions
####################



####################
# chatGPT functions
####################

async def chatgpt_generate_search_results(client: OpenAI, user_prompt: str, temp: float = 0.5) -> SearchResult:
    system_prompt = """
    You are a professional digital marketing expert. For a given prompt, you will generate up to 10 search result responses related to the query. Each response should include:

    - A rank from 1 to 10 (1 being the most relevant).
    - The type of result (choose one of: business, person, product, or service).
    - The name of the entity.
    - A concise description.
    - The URL of the entity (optional).

    Return the results as a list with the fields clearly defined, suitable for JSON parsing.
    """

    response = client.responses.parse(
        model="gpt-4o-2024-08-06",
        input=[
            {"role": "system", "content": system_prompt.strip()},
            {"role": "user", "content": user_prompt.strip()},
        ],
        temperature=temp,
        text_format=SearchResults,
    )

    return response.output_parsed

async def chatgpt_evaluate_search_target(client: OpenAI, user_prompt: str, search_target: SearchTarget, temp: float = 0.5):
    search_results = await chatgpt_generate_search_results(client = client, user_prompt = user_prompt, temp = temp)
    target_result = await find_search_target(client = client, search_target = search_target, results = search_results.results)
    return target_result

# Helper async function
async def run_chatgpt_call(client: OpenAI, prompt, target, epoch, temp):
    response = await chatgpt_evaluate_search_target(
        client = client,
        user_prompt = prompt.prompt,
        search_target = target,
        temp = temp
    )
    return SearchPromptResult(
        promptId = prompt.promptId,
        epoch = epoch,
        llm = LLM.chatgpt,
        temperature = temp,
        search_target_found = response.search_target_found,
        search_target_rank = response.search_target_rank
    )

####################
# endpoints
####################

# client = None

# @app.on_event("startup")
# async def startup_event():
#     global client
#     client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

@app.get("/")
def health_check():
    return {"message": "chatGPT API is alive!"}

@app.post("/chatgpt-search", response_model=SearchResponse)
async def run_ai_search(request: RunRequest,
                         authenticated: bool = Depends(verify_supabase_user),
                         client: OpenAI = Depends(get_openai_client), 
                         supabase: Client = Depends(get_supabase_client)):
    try:
        target = request.searchTarget
        epochs = 10
        tasks = []
        data = fetch_data(report_id = request.reportId, supabase = supabase)
        for epoch in range(epochs):
            temp = sample_temperature()
            for prompt in data.prompts:
                tasks.append(run_chatgpt_call(client, prompt, target, epoch, temp))
                # tasks.append(run_gemini_call(client, prompt, target, epoch, temp))
        results = await asyncio.gather(*tasks)
        search_response = SearchResponse(reportId = request.reportId, searchResults = results)
        # TODO save search_response to supabase
        return JSONResponse(status_code=200, content={"success": True})
    
    except Exception as e:
        # Log the exception details
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail="Internal Server Error")
