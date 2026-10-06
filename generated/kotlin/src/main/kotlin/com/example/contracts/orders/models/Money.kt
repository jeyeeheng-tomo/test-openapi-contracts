package com.example.contracts.orders.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Pattern
import kotlin.Long
import kotlin.String

public data class Money(
  /**
   * Amount in the currency's minor unit (e.g. cents). Never a float.
   */
  @param:JsonProperty("amount_minor")
  @get:JsonProperty("amount_minor")
  @get:NotNull
  public val amountMinor: Long,
  /**
   * ISO 4217 code.
   */
  @param:JsonProperty("currency")
  @get:JsonProperty("currency")
  @get:NotNull
  @get:Pattern(regexp = "^[A-Z]{3}${'$'}")
  public val currency: String,
)
