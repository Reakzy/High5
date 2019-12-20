package high5.team.high5.View

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import high5.team.high5.Activity.ChatActivity
import high5.team.high5.Model.Message
import high5.team.high5.Model.User
import high5.team.high5.R


class MessageView(private val context: Context, private val messageList: List<Message>, private val user: User?, private val usersList : List<User>) : BaseAdapter() {
    private var date : high5.team.high5.Utils.Date = high5.team.high5.Utils.Date()

    override fun getViewTypeCount(): Int {
        return if (count > 0) {
            count
        } else {
            super.getViewTypeCount()
        }
    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun getCount(): Int {
        return messageList.size
    }

    override fun getItem(position: Int): Any {
        return messageList[position]
    }

    override fun getItemId(position: Int): Long {
        return 0
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        var newConvertView = convertView
        val holder: MessageView.ViewHolder

        if (newConvertView == null) {
            holder = ViewHolder()
            val inflater = context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater

            if (user!!.id == messageList[position].createdBy) {
                newConvertView = inflater.inflate(R.layout.send_message, null, true)
            }
            else {
                newConvertView = inflater.inflate(R.layout.reveice_message, null, true)
                holder.userName = newConvertView.findViewById(R.id.text_message_name) as TextView
                for (userMessage in usersList)
                {
                    if (userMessage.id == messageList[position].createdBy)
                        holder.userName!!.text = userMessage.fullName
                }
            }

            holder.content = newConvertView!!.findViewById(R.id.text_message_body) as TextView
            holder.horaryText = newConvertView.findViewById(R.id.text_message_time) as TextView

            newConvertView.tag = holder
        }
        else {
            // the getTag returns the viewHolder object set as a tag to the view
            holder = newConvertView.tag as ViewHolder
        }

        holder.content!!.text = messageList[position].content
        holder.horaryText!!.text = date.transformDbToView(messageList[position].createdAt, "dd/MM/yyyy HH:mm")
        return newConvertView
    }

    private inner class ViewHolder {
        var content: TextView? = null
        var userName: TextView? = null
        var horaryText: TextView? = null
        var imageProfileMessage : ImageView? = null
    }
}
