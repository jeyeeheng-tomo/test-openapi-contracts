package com.example.contracts.users.models

import com.fasterxml.jackson.`annotation`.JsonAnyGetter
import com.fasterxml.jackson.`annotation`.JsonAnySetter
import com.fasterxml.jackson.`annotation`.JsonIgnore
import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.constraints.Size
import kotlin.Any
import kotlin.String
import kotlin.collections.Map
import kotlin.collections.MutableMap

public data class UpdateUserRequest(
  @param:JsonProperty("display_name")
  @get:JsonProperty("display_name")
  @get:Size(
    min = 1,
    max = 120,
  )
  public val displayName: String? = null,
  @param:JsonProperty("status")
  @get:JsonProperty("status")
  public val status: UpdateUserRequestStatus? = null,
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
