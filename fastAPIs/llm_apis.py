#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 13 10:15:06 2025

@author: jesse
"""

from fastapi import FastAPI
from pydantic import BaseModel, Field
from openai import OpenAI
from enum import Enum
from typing import List, Optional
import os
import random
import asyncio

app = FastAPI()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

####################
# Classes
####################

class SearchTargetType(str, Enum):
    product = "product"
    service = "service"
    business = "business"
    person = "person"

class SearchTarget(BaseModel):
    type: SearchTargetType
    name: str
    description: str
    url: Optional[str] = None

class Prompt(BaseModel):
    promptId: str
    prompt: str

class SearchRequest(BaseModel):
    reportId: str
    searchTarget: SearchTarget
    prompts: List[Prompt]

class LLM(str, Enum):
    chatgpt = "chatgpt"
    gemini = "gemini"

class SearchPromptResult(BaseModel):
    promptId: str
    epoch: int
    llm: LLM
    temperature: float
    search_target_found: bool
    search_target_rank: Optional[int] = None

class SearchResponse(BaseModel):
    reportId: str
    searchResults: List[SearchPromptResult]

####################
# Step 1
####################

class SearchResultType(str, Enum):
    product = "product"
    service = "service"
    business = "business"
    person = "person"

class SearchResult_01(BaseModel):
    type: SearchResultType
    rank: int
    name: str
    description: str
    url: Optional[str] = None

class SearchResults_01(BaseModel):
    results: List[SearchResult_01]

async def call_chatgpt_01(user_prompt: str, temp: float = 0.5) -> SearchResults_01:
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
        text_format=SearchResults_01,
    )

    return response.output_parsed

####################
# Step 2
####################

class SearchTargetResult(BaseModel):
    search_target_found: bool
    search_target_rank: Optional[int] = None

async def call_chatgpt_02(search_target: SearchTarget, results: List[SearchResult_01], temp: float = 0.0) -> SearchTargetResult:

    system_prompt = """
    You are a precise assistant who answers the following in **strict JSON format**:

    {
      "search_target_found": true | false,
      "rank": integer | null
    }

    Rules:
    - If the target is found, set "search_target_found" to true and "rank" to the integer rank where it appears.
    - If not found, set "search_target_found" to false and "rank" to null.
    Do not add any extra text.
    """


    # Compose a user prompt summarizing the results and asking if the search target is present
    results_summary = "\n".join([
        f"{r.rank}. {r.name} ({r.type}): {r.description} - {r.url}"
        for r in results
    ])
    
    user_prompt = f"""
    Given the following search results:

    {results_summary}

    Does the list above contain the search target:

    type: {search_target.type.value}
    name: {search_target.name}
    description: {search_target.description}
    url: {search_target.url or "N/A"}
    """
    
    response = client.responses.parse(
        model="gpt-4o-2024-08-06",
        input=[
            {"role": "system", "content": system_prompt.strip()},
            {"role": "user", "content": user_prompt.strip()},
        ],
        temperature=temp,
        text_format=SearchTargetResult,
    )
    
    return response.output_parsed


####################
# Functions
####################
async def call_chatgpt(user_prompt: str, search_target: SearchTarget, temp: float = 0.5):
    result_01 = await call_chatgpt_01(user_prompt = user_prompt, temp = temp)
    result_02 = await call_chatgpt_02(search_target = search_target, results = result_01.results)
    return result_02

# Helper async function
async def run_llm_call(prompt, target, epoch, temp):
    response = await call_chatgpt(
        user_prompt=prompt.prompt,
        search_target=target,
        temp=temp
    )
    return SearchPromptResult(
        promptId=prompt.promptId,
        epoch=epoch,
        llm=LLM.chatgpt,
        temperature=temp,
        search_target_found=response.search_target_found,
        search_target_rank=response.search_target_rank
    )

####################
# Endpoint
####################

@app.get("/")
def health_check():
    return {"message": "API is alive!"}

@app.post("/ai-search", response_model=SearchResponse)
async def ai_search(request: SearchRequest):
    results = []
    target = request.searchTarget
    temp_range = (0.5, 0.75)  # Reasonable range
    epochs = 3

    tasks = []

    for epoch in range(epochs):

        temp = round(random.uniform(*temp_range), 2)  # e.g. 0.42, 0.78

        # chatgpt
        for prompt in request.prompts:
            # response = call_chatgpt(user_prompt = prompt.prompt, search_target = target, temp = temp)
            # result = SearchPromptResult(
            #     promptId = prompt.promptId,
            #     epoch = epoch,
            #     llm = LLM.chatgpt, 
            #     temperature = temp, 
            #     search_target_found = response.search_target_found,
            #     search_target_rank = response.search_target_rank
            #     )
            # results.append(result)
            tasks.append(
                run_llm_call(prompt, target, epoch, temp)
            )
        
        results = await asyncio.gather(*tasks)
            

            # gemini
            # TODO

    return SearchResponse(reportId = request.reportId, searchResults = results)
