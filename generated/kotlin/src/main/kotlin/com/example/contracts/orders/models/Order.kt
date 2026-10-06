package com.example.contracts.orders.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.Valid
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Size
import java.time.Instant
import java.util.UUID
import kotlin.collections.List

public data class Order(
  @param:JsonProperty("created_at")
  @get:JsonProperty("created_at")
  @get:NotNull
  public val createdAt: Instant,
  @param:JsonProperty("updated_at")
  @get:JsonProperty("updated_at")
  @get:NotNull
  public val updatedAt: Instant,
  @param:JsonProperty("id")
  @get:JsonProperty("id")
  @get:NotNull
  public val id: UUID,
  /**
   * References `User.id` in the Users API.
   */
  @param:JsonProperty("user_id")
  @get:JsonProperty("user_id")
  @get:NotNull
  public val userId: UUID,
  @param:JsonProperty("status")
  @get:JsonProperty("status")
  @get:NotNull
  public val status: OrderStatus,
  @param:JsonProperty("items")
  @get:JsonProperty("items")
  @get:NotNull
  @get:Size(min = 1)
  @get:Valid
  public val items: List<OrderItem>,
  @param:JsonProperty("total")
  @get:JsonProperty("total")
  @get:NotNull
  @get:Valid
  public val total: Money,
)
