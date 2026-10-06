package com.example.contracts.users.models

import com.fasterxml.jackson.`annotation`.JsonValue
import kotlin.String
import kotlin.collections.Map

public enum class UpdateUserRequestStatus(
  @JsonValue
  public val `value`: String,
) {
  ACTIVE("active"),
  SUSPENDED("suspended"),
  DEACTIVATED("deactivated"),
  ;

  public companion object {
    private val mapping: Map<String, UpdateUserRequestStatus> =
        entries.associateBy(UpdateUserRequestStatus::value)

    public fun fromValue(`value`: String): UpdateUserRequestStatus? = mapping[value]
  }
}
