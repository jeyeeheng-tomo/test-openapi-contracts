package com.example.contracts.orders.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.NotNull
import java.time.Instant

public data class Timestamps(
  @param:JsonProperty("created_at")
  @get:JsonProperty("created_at")
  @get:NotNull
  public val createdAt: Instant,
  @param:JsonProperty("updated_at")
  @get:JsonProperty("updated_at")
  @get:NotNull
  public val updatedAt: Instant,
)
