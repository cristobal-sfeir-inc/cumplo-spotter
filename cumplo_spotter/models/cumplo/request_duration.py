"""Pydantic model for Cumplo funding request duration."""

from cumplo_common.models import DurationUnit
from pydantic import BaseModel, Field, field_validator


class CumploFundingRequestDuration(BaseModel):
    """Pydantic model for a Cumplo funding request's duration (plazo)."""

    unit: DurationUnit = Field(..., alias="type")
    value: int = Field(...)

    def __str__(self) -> str:
        """Return a human-readable string representation of the duration."""
        return f"{self.value} {self.unit}"

    @field_validator("unit", mode="before")
    @classmethod
    def unit_formatter(cls, value: str) -> DurationUnit:
        """Format the unit value."""
        return DurationUnit(value.strip().upper())
