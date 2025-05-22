#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 21 11:59:13 2025

@author: jesse
"""

import os
import random
from openai import OpenAI
from typing import List
from supabase import create_client, Client
from classes import SearchTarget, SearchResult, SearchTargetResult, Prompt, SearchData, Report
from fastapi import HTTPException, Request

####################
# API clients
####################

def get_openai_client():
    client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    return client

def get_supabase_client():
    url: str = 'https://evekbdfpapkdsmsxnhcc.supabase.co'
    key: str = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2ZWtiZGZwYXBrZHNtc3huaGNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0Mzk3NjMsImV4cCI6MjA2MzAxNTc2M30.7bL6wXGb6PqyFCLvlgC3Ug_xJE4ReejddA3XuPrYV24'
    # url: str = os.environ.get("SUPABASE_URL")
    # key: str = os.environ.get("SUPABASE_KEY")
    supabase: Client = create_client(url, key)
    return supabase

def verify_supabase_user(request: Request):
    auth_header = request.headers.get("authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Unauthorized")
    jwt = auth_header.split(" ")[1]
    # Minimal verification for demonstration purposes
    if jwt != os.getenv("FAKE_VALID_JWT"):  # Replace with actual Supabase JWT verification
        raise HTTPException(status_code=401, detail="Invalid token")
    return True

####################
# functions
####################

def sample_temperature(min_temp=0.5, max_temp=0.75) -> float:
    return round(random.uniform(min_temp, max_temp), 2)

async def find_search_target(client: OpenAI, search_target: SearchTarget, results: List[SearchResult], temp: float = 0.3) -> SearchTargetResult:

    system_prompt = """
    You are a precise assistant who answers the following in **strict JSON format**:

    {
      "search_target_found": true | false,
      "rank": integer | null
    }

    You are comparing a list of search results against a search target. Consider name, description, and URL, and allow for small variations.

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
# fetch data
####################

def fetch_data(report_id: str, supabase: Client) -> SearchData:
    
    # report
    report_response = (
        supabase.table("reports")
        .select("*")
        .eq("id", report_id)
        .single()
        .execute()
    )
    report = Report(**report_response.data)
    
    # search target
    search_target_response = (
        supabase.table("search_targets")
        .select("*")
        .eq("report_id", report_id)
        .single()
        .execute()
    )
    search_target = SearchTarget(**search_target_response.data)
    
    # prompts
    prompt_response = (
        supabase.table("prompts")
        .select("id, report_id, prompt, created_at, updated_at, deleted_at")
        .eq("report_id", report_id)
        .execute()
    )
    
    # map to list of Prompt class
    prompts: List[Prompt] = [Prompt(**item) for item in prompt_response.data]
    
    # prepare payload    
    payload = SearchData(
        report_id = report.id,
        search_target = search_target,
        prompts = prompts
        )
    
    return payload
