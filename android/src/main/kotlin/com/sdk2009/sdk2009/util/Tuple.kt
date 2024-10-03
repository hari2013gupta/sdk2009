package com.sdk2009.sdk2009.util

import java.io.Serializable

data class Tuple<out X, out Y>(
    val item1: X,
    val item2: Y
) : Serializable {

    /**
     * Returns string representation of the [Tuple] including its [item1] and [item2] values.
     */
    override fun toString(): String = "($item1, $item2)"
}
