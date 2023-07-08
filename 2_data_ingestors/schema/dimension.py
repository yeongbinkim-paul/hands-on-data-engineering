import pydantic
from pydantic import BaseModel

class DateDimension(BaseModel):
    date: str
    year: int
    month: int
    day: int
    day_of_week: str
    day_of_week_kr: str
