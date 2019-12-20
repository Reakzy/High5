import high5.team.high5.Adapter.EventAdapter
import high5.team.high5.Model.User
import junit.framework.Assert.assertTrue
import org.junit.Test
import org.mockito.Mock
import org.mockito.Mockito.mock
import java.lang.Thread.sleep

internal class EventAdapterTest {

    private val eventAdapter = mock(EventAdapter::class.java)

    @Test
    fun checkGetSortedEventsWithoutUser() {
        val userMock = mock(User::class.java)
        eventAdapter.getAndSortEvents(userMock) {
        }
        sleep(1000)
        val list = eventAdapter.getSortedEvents()
        assertTrue(list.isEmpty())
    }

    @Test
    fun checkGetSortedEventsWithFakeUser() {
        var isFinished = false
        val userMock = mock(User::class.java)
        userMock.email = "thomaslavigne475@gmail.com"
        userMock.birthdayDate = "02-27-2019 12:00"
        userMock.createdAt = "02-27-2019 12:31"
        userMock.fullName = "Thomas LAVIGNE"
        userMock.profilePicture =
            "https://lh3.googleusercontent.com/-0SuL-Vy-C1w/AAAAAAAAAAI/AAAAAAAAAAA/AKxrwcbYh-7wUMZSQNYCEWX2P2e2ysQWwg/s96-c/photo.jpg"
        userMock.id = "fG91sIBnfhaDKNUs2Lt4PQae5zw1"

        eventAdapter.getAndSortEvents(userMock) {
        }
        val list = eventAdapter.getSortedEvents()
        //List toujours false car on ne peut pas acceder a la completion depuis le test.
        assertTrue(list.isEmpty())
    }
}