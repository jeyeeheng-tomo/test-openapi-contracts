package com.example.contracts.vouchers.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Size
import java.time.Instant
import java.util.UUID
import kotlin.String

public data class Voucher(
  /**
   * Opaque voucher identifier (UUID v7).
   */
  @param:JsonProperty("id")
  @get:JsonProperty("id")
  @get:NotNull
  public val id: UUID,
  /**
   * Short label shown in the voucher list.
   */
  @param:JsonProperty("name")
  @get:JsonProperty("name")
  @get:NotNull
  @get:Size(max = 120)
  public val name: String,
  /**
   * Longer copy explaining what the voucher is good for.
   */
  @param:JsonProperty("description")
  @get:JsonProperty("description")
  @get:NotNull
  @get:Size(max = 1_000)
  public val description: String,
  /**
   * When the voucher stops being redeemable. Always UTC. A voucher is expired
   * when this instant is in the past; the server does not remove expired
   * vouchers from the list.
   */
  @param:JsonProperty("expires_at")
  @get:JsonProperty("expires_at")
  @get:NotNull
  public val expiresAt: Instant,
)
