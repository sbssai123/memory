import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<MatchingGame channel={channel} />, root);
}

// Represents the entire game
class MatchingGame extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = { tiles: [], current_tiles: [], matched: [], players: {}, winner: "" };
    this.channel.join()
        .receive("ok", this.gotView.bind(this))
        .receive("error", resp => { console.log("Unable to join", resp) });

    this.channel.on("change_view", (state) => {
       if (state !== undefined) {
           this.setState(state);
       }
     });
  }

  gotView(view) {
    console.log("new view", view);
    this.setState(view.game);
  }

  handleClick(i) {
    this.channel.push("click", { tile_index: i })
    .receive("ok", this.gotView.bind(this));
    if(this.state.current_tiles.length == 1) {
      console.log("here");
      this.channel.push("match", {tile_index: i})
      .receive("ok", this.gotView.bind(this));
    }
  }


  reset() {
    this.channel.push("reset", { filler: 1 }).receive("ok", this.gotView.bind(this));
  }

  // Renders a Tile from the game's tiles given an index.
  renderTile(i) {
    let letter = this.state.tiles[i];
    let flipped = this.state.current_tiles.includes(i);
    let matched = this.state.matched.includes(i);
    return letter ? (<Tile flipped={flipped} letter={letter} matched={matched} onClick={() => this.handleClick(i)}/>) : <div/>;
  }

  renderScores() {
    let players = this.state.players;
    let spans = [];

    if (players) {
      let keys = Object.keys(players);
      if (keys.length < 2) {
        return(<span>Waiting for another player...</span>)
      }
      for (let i = 0; i < keys.length; i++) {
        let key = keys[i];
        let score = players[key].matches;
        let turn = players[key].turn;
        if (turn != -1) {
          let temp = (<span>{key} : {score} </span>);
          spans.push(temp);
        }
      }
    }
    return (<div>Scores: {spans}</div>)
  }

  renderTurn() {
    let players = this.state.players;
    if (players) {
      let keys = Object.keys(players);
      if (keys.length > 1) {
        for (let i = 0; i < keys.length; i++) {
          let key = keys[i];
          let turn = players[key].turn;
          if (turn == 1) {
            return(<span>Current Turn: {key}</span>)
          }
        }
      }
    }
  }

  renderWinner() {
  if (this.state.winner) {
    return (<h5> Winner: {this.state.winner} </h5>)
  }
}

  // Renders the entire game
  render() {
    return(
      <div>
        <div className="row">
          <button id="reset" onClick={() => this.reset()}>Reset Game</button>
          <div id="scores">{this.renderScores()}</div>
          <div id="turn"> {this.renderTurn()}</div>
          <div id="winner">{this.renderWinner()}</div>
        </div>
        <div className="row">
            {this.renderTile(0)}
            {this.renderTile(1)}
            {this.renderTile(2)}
            {this.renderTile(3)}
        </div>
      <div className="row">
          {this.renderTile(4)}
          {this.renderTile(5)}
          {this.renderTile(6)}
          {this.renderTile(7)}
      </div>
      <div className="row">
          {this.renderTile(8)}
          {this.renderTile(9)}
          {this.renderTile(10)}
          {this.renderTile(11)}
      </div>
      <div className="row">
          {this.renderTile(12)}
          {this.renderTile(13)}
          {this.renderTile(14)}
          {this.renderTile(15)}
      </div>
    </div>
    );
  }
}

// Represents a Tile
function Tile(params) {
  let flipped = params.flipped ? "show" : "back-side";
  let tile_id = params.matched ? "match" : flipped;
  // content before determining if an item was matched
  let before_match = params.flipped ? params.letter : "?";
  let content = params.matched ? "✔" : before_match;
  let click = params.flipped ? undefined : params.onClick;
      return (
        <a className="tile" id={tile_id} onClick={click}>
          <p id="tile-content">{content}</p>
        </a>
      );
}
