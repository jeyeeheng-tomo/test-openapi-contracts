package com.example.contracts.users.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.NotNull
import kotlin.Any
import kotlin.String
import kotlin.collections.Map

public data class Unauthorized(
  /**
   * Stable, machine-readable error code.
   */
  @param:JsonProperty("code")
  @get:JsonProperty("code")
  @get:NotNull
  public val code: String,
  /**
   * Human-readable explanation. Do not parse this.
   */
  @param:JsonProperty("message")
  @get:JsonProperty("message")
  @get:NotNull
  public val message: String,
  /**
   * Optional structured context for the error.
   */
  @param:JsonProperty("details")
  @get:JsonProperty("details")
  public val details: Map<String, Any?>? = null,
)
