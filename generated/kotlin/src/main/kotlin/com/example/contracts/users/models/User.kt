package com.example.contracts.users.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Size
import java.time.Instant
import java.util.UUID
import kotlin.String

public data class User(
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
  @param:JsonProperty("email")
  @get:JsonProperty("email")
  @get:NotNull
  public val email: String,
  @param:JsonProperty("display_name")
  @get:JsonProperty("display_name")
  @get:NotNull
  @get:Size(max = 120)
  public val displayName: String,
  @param:JsonProperty("status")
  @get:JsonProperty("status")
  @get:NotNull
  public val status: UserStatus,
)
