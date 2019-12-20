package high5.team.high5.Activity

import android.content.Intent
import android.os.Bundle
import android.widget.ListView
import high5.team.high5.View.EventView
import high5.team.high5.Model.User
import android.support.v7.app.AppCompatActivity
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.MobileAds
import high5.team.high5.R
import high5.team.high5.Adapter.EventAdapter
import kotlinx.android.synthetic.main.activity_event_list.*


class EventActivity : AppCompatActivity() {

    private val TAG = "EventListActivity"

    private var lv: ListView? = null

    private var customeView: EventView? = null

    private var eventAdapter: EventAdapter = EventAdapter()

    private var user: User? = null

    override fun onBackPressed() {
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_event_list)

        val mAdView: AdView = findViewById(R.id.adView)
        val adRequest = AdRequest.Builder().build()
        mAdView.loadAd(adRequest)

        lv = findViewById(R.id.listView)

        user = intent.getSerializableExtra("User") as? User

        eventAdapter.getAndSortEvents(user!!) {
            customeView = EventView(applicationContext, eventAdapter.getSortedEvents(), user!!, eventAdapter.getChangedPosition())
            if (customeView != null)
                lv!!.adapter = customeView
        }

        navigationView.setOnNavigationItemSelectedListener { item ->
            when (item.itemId) {
                R.id.navigation_profile -> {
                    val intent = Intent(this, ProfileActivity::class.java)
                    intent.putExtra("User", user)
                    this.startActivity(intent)
                    true
                }
                R.id.navigation_home -> {
                    true
                }
                R.id.navigation_add_event -> {
                    val intent = Intent(this, EventCreateActivity::class.java)
                    intent.putExtra("User", user)
                    this.startActivity(intent)
                    true
                }
                else -> {
                    false
                }
            }
        }
    }


}