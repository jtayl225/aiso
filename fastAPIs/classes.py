#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 21 08:21:12 2025

@author: jesse
"""

from pydantic import BaseModel, Field
from typing import List, Optional
from enum import Enum
from datetime import datetime

class BaseSchema(BaseModel):
    class Config:
        validate_by_name = True
        from_attributes = True

####################
# enums
####################

class LLM(str, Enum):
    chatgpt = "chatgpt"
    gemini = "gemini"

class EntityType(str, Enum):
    product = "product"
    service = "service"
    business = "business"
    person = "person"
    
####################
# classes
####################

class Report(BaseModel):
    id: str
    user_id: str
    title: str
    cadence: str
    created_at: Optional[datetime]  
    updated_at: Optional[datetime]
    deleted_at: Optional[datetime]
    last_run_at: Optional[datetime]
    
class SearchTarget(BaseModel):
    id: str
    report_id: str
    name: str
    type: EntityType
    description: str
    url: Optional[str]
    created_at: Optional[datetime]  
    updated_at: Optional[datetime]
    deleted_at: Optional[datetime]
    
class Prompt(BaseModel):
    id: str
    report_id: str
    prompt: str
    created_at: Optional[datetime]  
    updated_at: Optional[datetime]
    deleted_at: Optional[datetime]

####################
# API request
####################

class SearchData(BaseSchema):
    report_id: str = Field(..., alias="reportId")
    search_target: SearchTarget = Field(..., alias="searchTarget")
    prompts: List[Prompt]
    
class RunRequest(BaseSchema):
    report_id: str = Field(..., alias="reportId")
    
####################
# API response
####################

# step 1: search AI with prompts
class SearchResult(BaseModel):
    type: EntityType
    rank: int
    name: str
    description: str
    url: Optional[str] = None

class SearchResults(BaseModel):
    results: List[SearchResult]
    
# step 2: confirm if search target is in search results    
class SearchTargetResult(BaseModel):
    search_target_found: bool
    search_target_rank: Optional[int] = None
 
# step 3: format data for return       
class SearchPromptResult(BaseSchema):
    report_id: str = Field(..., alias="reportId")
    epoch: int
    llm: LLM
    temperature: float
    search_target_found: bool
    search_target_rank: Optional[int] = None

class SearchResponse(BaseSchema):
    report_id: str = Field(..., alias="reportId")
    search_results: List[SearchPromptResult] = Field(..., alias="searchResults")
