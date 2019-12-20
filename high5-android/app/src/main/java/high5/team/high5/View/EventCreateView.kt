package high5.team.high5.View

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import high5.team.high5.Model.Event
import high5.team.high5.R

class EventCreateView(private val context: Context, private val event: Event) : BaseAdapter() {

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemViewType(position: Int): Int {
        return 0
    }

    override fun getCount(): Int {
        return 1
    }

    override fun getItem(position: Int): Any {
        return event
    }

    override fun getItemId(position: Int): Long {
        return 0
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        var convertView = convertView
        val holder:ViewHolder

        if (convertView == null) {
            holder = ViewHolder()
            val inflater = context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
            convertView = inflater.inflate(R.layout.event, null, true)

            holder.name = convertView!!.findViewById(R.id.name) as TextView
            holder.description = convertView.findViewById(R.id.description) as TextView
            holder.eventAt = convertView.findViewById(R.id.txtDate) as TextView
            holder.place = convertView.findViewById(R.id.place) as TextView
            //holder.userMaxNumber = convertView.findViewById(R.id.user_max_number) as TextView

            convertView.tag = holder
        } else {
            // the getTag returns the viewHolder object set as a tag to the view
            holder = convertView.tag as EventCreateView.ViewHolder
        }

        holder.name!!.text = event.name
        holder.description!!.text = event.description
        holder.eventAt!!.text = event.eventAt
        holder.place!!.text = event.place
        holder.userMaxNumber!!.text = event.userMaxNumber.toString()

        return convertView
    }

    private inner class ViewHolder {
        var name: TextView? = null
        var description: TextView? = null
        var eventAt: TextView? = null
        var place: TextView? = null
        var userMaxNumber: TextView? = null
    }
}
