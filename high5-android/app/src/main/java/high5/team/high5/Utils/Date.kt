package high5.team.high5.Utils

import android.util.Log
import android.widget.EditText
import java.text.SimpleDateFormat
import java.util.*
import java.util.Date

class Date {
    fun utcDate(formatDate: String = "MM-dd-yyyy HH:mm:ss:SSS"): String {
        val dateFormatGmt = SimpleDateFormat(formatDate)
        dateFormatGmt.timeZone = TimeZone.getTimeZone("GMT+1")
        return dateFormatGmt.format(Date())
    }

    fun updateDateInView(dateText: EditText?, calendar : Calendar, formatDate: String = "dd/MM/yyyy HH:mm") {
        val sdf = SimpleDateFormat(formatDate, Locale.FRANCE)
        dateText!!.setText(sdf.format(calendar.time))
    }

    fun updateDate(formatDate: String, calendar : Calendar): String? {
        val sdf = SimpleDateFormat(formatDate, Locale.FRANCE)
        return sdf.format(calendar.time)
    }

    fun transformDbToView(dateString: String, formatDate: String = "dd/MM/yyyy HH:mm"): String? {
        val parser = SimpleDateFormat("MM-dd-yyyy HH:mm")
        val formatter = SimpleDateFormat(formatDate, Locale.FRANCE)
        return formatter.format(parser.parse(dateString))
    }

    fun getCalendar(dateString: String, calendar: Calendar, dateFormat: String = "dd/MM/yyyy HH:mm") {
        val formatter = SimpleDateFormat(dateFormat)
        val date = formatter.parse(dateString)
        calendar.time = date
    }
}