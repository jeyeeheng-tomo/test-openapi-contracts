package com.example.contracts.offers.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Size
import java.util.UUID
import kotlin.String

public data class Offer(
  /**
   * Opaque offer identifier (UUID v7).
   */
  @param:JsonProperty("id")
  @get:JsonProperty("id")
  @get:NotNull
  public val id: UUID,
  /**
   * Short headline shown in the offer list.
   */
  @param:JsonProperty("title")
  @get:JsonProperty("title")
  @get:NotNull
  @get:Size(max = 120)
  public val title: String,
  /**
   * Longer copy explaining the offer.
   */
  @param:JsonProperty("description")
  @get:JsonProperty("description")
  @get:NotNull
  @get:Size(max = 1_000)
  public val description: String,
)
