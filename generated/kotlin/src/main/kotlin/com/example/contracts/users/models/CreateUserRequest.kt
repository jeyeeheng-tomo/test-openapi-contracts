package com.example.contracts.users.models

import com.fasterxml.jackson.`annotation`.JsonAnyGetter
import com.fasterxml.jackson.`annotation`.JsonAnySetter
import com.fasterxml.jackson.`annotation`.JsonIgnore
import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Size
import kotlin.Any
import kotlin.String
import kotlin.collections.Map
import kotlin.collections.MutableMap

public data class CreateUserRequest(
  @param:JsonProperty("email")
  @get:JsonProperty("email")
  @get:NotNull
  public val email: String,
  @param:JsonProperty("display_name")
  @get:JsonProperty("display_name")
  @get:NotNull
  @get:Size(
    min = 1,
    max = 120,
  )
  public val displayName: String,
  @get:JsonIgnore
  public val properties: MutableMap<String, Any?> = mutableMapOf(),
) {
  @JsonAnyGetter
  public fun `get`(): Map<String, Any?> = properties

  @JsonAnySetter
  public fun `set`(name: String, `value`: Any?) {
    properties[name] = value
  }
}
