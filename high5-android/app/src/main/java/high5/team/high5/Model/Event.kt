package high5.team.high5.Model

import java.io.Serializable
import java.util.*

class Event : Serializable
{
    var id: String? = ""
    var name: String = ""
    var groupePicture: String = ""
    var description: String = ""
    var eventAt: String = ""
    var createdBy: String = ""
    var place: String = ""
    var userIds : MutableList<String> = mutableListOf()
    var waitingUserIds : MutableList<String> = mutableListOf()
    var createdAt: String = ""
    var updatedAt: String = ""
    var userMaxNumber: Int = 8

    fun addUserId(userId: String) {
        this.userIds.add(userId)
    }

    fun addWaitingUserId(userId: String) {
        this.waitingUserIds.add(userId)
    }

    fun removeWaitingUserId(userId: String) {
        this.waitingUserIds.remove(userId)
    }

    fun removeUserId(userId: String) {
        this.waitingUserIds.remove(userId)
        this.userIds.remove(userId)
    }

    fun isInEvent(userId: String): Boolean {
        return (userIds.contains(userId) || waitingUserIds.contains(userId))
    }
}