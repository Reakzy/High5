package high5.team.high5.Model

import java.io.Serializable
import java.util.*

class Message : Serializable {
    @Transient var id: String = ""
    var eventId: String = ""
    var createdAt: String = ""
    var createdBy: String = ""
    var content: String = ""
}