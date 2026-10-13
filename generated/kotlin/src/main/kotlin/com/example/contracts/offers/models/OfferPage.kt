package com.example.contracts.offers.models

import com.fasterxml.jackson.`annotation`.JsonProperty
import jakarta.validation.Valid
import jakarta.validation.constraints.NotNull
import kotlin.String
import kotlin.collections.List

public data class OfferPage(
  @param:JsonProperty("data")
  @get:JsonProperty("data")
  @get:NotNull
  @get:Valid
  public val `data`: List<Offer>,
  /**
   * Pass as `page_token` to fetch the next page. Absent on the last page.
   */
  @param:JsonProperty("next_page_token")
  @get:JsonProperty("next_page_token")
  public val nextPageToken: String? = null,
)
