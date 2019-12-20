package high5.team.high5.View

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import com.squareup.picasso.Picasso
import high5.team.high5.Activity.ChatActivity
import high5.team.high5.Activity.EventDetailsActivity
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import high5.team.high5.R
import kotlinx.android.synthetic.main.event.view.*
import java.net.URI

class EventView(private val context: Context, private val eventList: List<Event>, private val user: User?, private val positionToChange: Int) : BaseAdapter() {

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
        return eventList.size
    }

    override fun getItem(position: Int): Any {
        return eventList[position]
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
            if (position == 0 && positionToChange != 0) {
                newConvertView = inflater.inflate(R.layout.first_event, null, true)
                holder.joinButton = newConvertView.findViewById(R.id.buttonRejoindre) as Button
                holder.joinButton!!.text = "Chat"
            }
            else if (positionToChange == position) {
                newConvertView = inflater.inflate(R.layout.first_event, null, true)
                holder.headerAboveEvent = newConvertView.findViewById(R.id.title) as TextView
                holder.joinButton = newConvertView.findViewById(R.id.buttonRejoindre) as Button
                holder.headerAboveEvent!!.text = "Groupes Disponibles"
            }
            else if (positionToChange > position) {
                newConvertView = inflater.inflate(R.layout.event, null, true)
                holder.joinButton = newConvertView.findViewById(R.id.buttonRejoindre) as Button
                holder.joinButton!!.text = "Chat"
            }
            else
                newConvertView = inflater.inflate(R.layout.event, null, true)

            holder.joinButton = newConvertView.findViewById(R.id.buttonRejoindre) as Button
            if (eventList[position].waitingUserIds.contains(user!!.id))
                holder.joinButton!!.text = "En attente"

            holder.name = newConvertView!!.findViewById(R.id.name) as TextView
            holder.imgBackground = newConvertView.findViewById(R.id.imgView) as ImageView
            holder.joinButton = newConvertView.findViewById(R.id.buttonRejoindre) as Button
            holder.eventAt = newConvertView.findViewById(R.id.eventAt) as TextView
            holder.place = newConvertView.findViewById(R.id.place) as TextView
            holder.nbPlaces = newConvertView.findViewById(R.id.nbPersonne)

            holder.joinButton!!.setOnClickListener {
                val intent : Intent
                if (holder.joinButton!!.text == "Chat")
                    intent = Intent(context, ChatActivity::class.java)
                else
                    intent = Intent(context, EventDetailsActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                intent.putExtra("User", user)
                intent.putExtra("Event", eventList[position])
                context.startActivity(intent)
            }
            newConvertView.tag = holder
        } else {
            holder = newConvertView.tag as ViewHolder
        }
        var userNumber : String = eventList[position].userIds.size.toString()
        userNumber += " / "
        userNumber += eventList[position].userMaxNumber
        holder.name!!.text = eventList[position].name
        if (eventList[position].groupePicture !== "") {
            Picasso.get().load(eventList[position].groupePicture).resize(300, 165).into(holder.imgBackground)
        }
        holder.place!!.text = eventList[position].place
        holder.nbPlaces!!.text = userNumber
        holder.eventAt!!.text = eventList[position].eventAt

        return newConvertView
    }

    private inner class ViewHolder {
        var name: TextView? = null
        var imgBackground: ImageView? = null
        var joinButton: Button? = null
        var eventAt: TextView? = null
        var headerAboveEvent: TextView? = null
        var place: TextView? = null
        var nbPlaces: TextView? = null
    }
}
