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
    llm: LLM
    search_target_found: bool

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

def call_chatgpt_01(user_prompt: str, temp: float = 0.5) -> SearchResults_01:
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

def call_chatgpt_02(search_target: SearchTarget, results: List[SearchResult_01], temp: float = 0.3) -> SearchTargetResult:

    system_prompt = """
    You are a precise assistant who answers TRUE or FALSE questions strictly.
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

    Please respond with only TRUE or FALSE.
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
def call_chatgpt(user_prompt: str, search_target: SearchTarget):
    result_01 = call_chatgpt_01(user_prompt = user_prompt)
    result_02 = call_chatgpt_02(search_target = search_target, results = result_01.results)
    return result_02

####################
# Endpoint
####################

@app.get("/")
def health_check():
    return {"message": "API is alive!"}

@app.post("/ai-search", response_model=SearchResponse)
def ai_search(request: SearchRequest):
    results = []
    target = request.searchTarget

    # chatgpt
    for prompt in request.prompts:
        response = call_chatgpt(user_prompt = prompt.prompt, search_target = target)
        result = SearchPromptResult(promptId = prompt.promptId, llm = LLM.chatgpt, search_target_found = response.search_target_found)
        results.append(result)

    # gemini
    # TODO

    return SearchResponse(reportId = request.reportId, searchResults = results)
