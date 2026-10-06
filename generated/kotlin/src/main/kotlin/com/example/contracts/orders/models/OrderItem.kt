package com.example.contracts.orders.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.Valid
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.NotNull
import kotlin.Int
import kotlin.String

public data class OrderItem(
  @param:JsonProperty("sku")
  @get:JsonProperty("sku")
  @get:NotNull
  public val sku: String,
  @param:JsonProperty("quantity")
  @get:JsonProperty("quantity")
  @get:NotNull
  @get:DecimalMin(
    value = "1",
    inclusive = true,
  )
  public val quantity: Int,
  @param:JsonProperty("unit_price")
  @get:JsonProperty("unit_price")
  @get:NotNull
  @get:Valid
  public val unitPrice: Money,
)
