import "phoenix_html"
import {Socket, Presence} from "phoenix"
import $ from "jquery"

if (window.userToken) {

  let show_points = false;
  let socket = new Socket("/socket", {params: {token: window.userToken}})

  socket.connect()

  let party = socket.channel("game_session:1", {})
  let presences = {}

  let listBy = (player, {metas: metas}) => {
    return { player: player }
  }
  let userList = document.getElementById("users")
  let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
      .map(presence => `<li>${presence.player}</a>`)
      .join("")
  }
  party.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    render(presences)
  })
  party.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    render(presences)
  })
  party.join()

}
