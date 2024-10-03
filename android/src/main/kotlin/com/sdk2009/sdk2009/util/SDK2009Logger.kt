package com.sdk2009.sdk2009.util

import java.util.logging.Logger

class SDK2009Logger {
    companion object {
//        val kLog = Logger.getLogger(this::class.java.simpleName)
        val kLog = Logger.getLogger(SDK2009Logger::class.java.name)
    }

    fun logg(message: String) {
        kLog.info(message)
    }
}