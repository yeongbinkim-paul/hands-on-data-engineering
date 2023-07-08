import pydantic
from pydantic import BaseModel

class BlogViewCount(BaseModel):
    date: str
    view_count: int
    followers_count: int
    followers_for_followers_count: int
    anonymous_count: int

class BlogVisitCount(BaseModel):
    date: str
    visit_count: int

class BlogFunnel(BaseModel):
    date: str
    funnel: int
    funnel_route: str
    rate: int

class BlogPostMetadata(BaseModel):
    date: str
    title: str
    log_number: str
    category_number: str
    parent_category_number: str
