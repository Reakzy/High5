package high5.team.high5.View

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import high5.team.high5.Activity.EventWaitingQueueActivity
import high5.team.high5.Adapter.EventWaitingQueueAdapter
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import high5.team.high5.R

class EventWaitingQueueView(private val context: Context, private val waitingUsers: MutableList<User>, private val user: User?, private val adapter: EventWaitingQueueAdapter, private val event: Event) : BaseAdapter() {

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
        return waitingUsers.size
    }

    override fun getItem(position: Int): Any {
        return waitingUsers[position]
    }

    override fun getItemId(position: Int): Long {
        return 0
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        var newConvertView = convertView
        val holder: ViewHolder

        if (newConvertView == null) {
            holder = ViewHolder()
            val inflater = context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater

            newConvertView = inflater.inflate(R.layout.activity_waiting_list_item, null, true)
            holder.acceptButton = newConvertView.findViewById<Button>(R.id.acceptButton) as Button
            holder.refuseButton = newConvertView.findViewById<Button>(R.id.refuseButton) as Button

            holder.acceptButton!!.setOnClickListener {
                adapter.addWaitingUserToEvent(event, waitingUsers[position])
            }

            holder.refuseButton!!.setOnClickListener {
                adapter.removeWaitingUserToEvent(event, waitingUsers[position])
            }

            holder.name = newConvertView!!.findViewById(R.id.name) as TextView

            holder.name!!.text = waitingUsers[position].fullName
            newConvertView.tag = holder
        }


        return newConvertView
    }

    private inner class ViewHolder {
        var name: TextView? = null
        var acceptButton: Button? = null
        var refuseButton: Button? = null
    }
}
