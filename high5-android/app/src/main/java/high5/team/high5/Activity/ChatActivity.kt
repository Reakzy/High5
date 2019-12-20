package high5.team.high5.Activity

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.ListView
import android.widget.Toast
import high5.team.high5.Adapter.MessageAdapter
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import high5.team.high5.R
import high5.team.high5.View.MessageView

class ChatActivity : AppCompatActivity() {
    private val TAG = "ChatActivity"

    private var user: User? = null
    private var event: Event? = null
    private var messageAdapter: MessageAdapter = MessageAdapter()

    private var lv: ListView? = null
    private var customeView: MessageView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_chat)
        lv = this.findViewById(R.id.recycler_view_chat)

        user = intent.getSerializableExtra("User") as? User

        event = intent.getSerializableExtra("Event") as? Event

        val chatBoxWrite = findViewById<EditText>(R.id.edittext_chatbox)
        val sendMessageButton = findViewById<Button>(R.id.button_chatbox_send)
        val goToDetailEvent = findViewById<Button>(R.id.go_to_event_detail)

        goToDetailEvent.setOnClickListener {
            finish()
            val intent = Intent(this, EventDetailsActivity::class.java)
            intent.putExtra("User", user)
            intent.putExtra("Event", event)
            this.startActivity(intent)
        }


        sendMessageButton.setOnClickListener {
            if (chatBoxWrite.text.trim().toString().isNotEmpty()) {
                messageAdapter.writtingMessage(chatBoxWrite.text.trim().toString(), user!!.id, event!!.id!!)
                messageAdapter.createFirebaseListener(event!!) {
                    messageAdapter.catchUsers(event!!) {
                        customeView =
                            MessageView(
                                applicationContext,
                                messageAdapter.getMessages(),
                                user,
                                messageAdapter.getUsers()
                            )
                        if (customeView != null)
                            lv!!.adapter = customeView
                    }
                }
            }
            chatBoxWrite.text.clear()
        }

        messageAdapter.createFirebaseListener(event!!) {
            messageAdapter.catchUsers(event!!) {
                customeView =
                    MessageView(applicationContext, messageAdapter.getMessages(), user, messageAdapter.getUsers())
                if (customeView != null)
                    lv!!.adapter = customeView
            }
        }
    }
}