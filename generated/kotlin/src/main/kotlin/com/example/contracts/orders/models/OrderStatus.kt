package com.example.contracts.orders.models

import com.fasterxml.jackson.`annotation`.JsonValue
import kotlin.String
import kotlin.collections.Map

public enum class OrderStatus(
  @JsonValue
  public val `value`: String,
) {
  PENDING("pending"),
  PAID("paid"),
  SHIPPED("shipped"),
  CANCELLED("cancelled"),
  ;

  public companion object {
    private val mapping: Map<String, OrderStatus> = entries.associateBy(OrderStatus::value)

    public fun fromValue(`value`: String): OrderStatus? = mapping[value]
  }
}
