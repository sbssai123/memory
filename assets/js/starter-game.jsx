import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root) {
  ReactDOM.render(<MatchingGame />, root);
}

// Represents the entire game
class MatchingGame extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tiles : this.initalizeTiles(),
      attempts: 0, // the number of times a user clicks
      last_tile: null // keeps track of the last tile clicked
    };
  }

// When given a list of tiles, randomly shuffles them.
// Shuffling function was based off of this tutorial:
// https://www.kirupa.com/html5/shuffling_array_js.htm
shuffle(tiles) {
    for (let i = tiles.length - 1; i>=0; i--) {
      let random_index = Math.floor(Math.random() * (i + 1));
      let item = tiles[random_index];
      tiles[random_index] = tiles[i];
      tiles[i] = item;
    }
  }

  // shuffle tiles at the start of the game
  // A tile is a dictionary that contains information about the letter and
  // whether it should be flipped at the current instance of the game,
  // exposing the letter
  initalizeTiles() {
    let tiles = [
              { letter: 'A', flipped: 0 },
              { letter: 'A', flipped: 0 },
              { letter: 'B', flipped: 0 },
              { letter: 'B', flipped: 0 },
              { letter: 'C', flipped: 0 },
              { letter: 'C', flipped: 0 },
              { letter: 'D', flipped: 0 },
              { letter: 'D', flipped: 0 },
              { letter: 'E', flipped: 0 },
              { letter: 'E', flipped: 0 },
              { letter: 'F', flipped: 0 },
              { letter: 'F', flipped: 0 },
              { letter: 'G', flipped: 0 },
              { letter: 'G', flipped: 0 },
              { letter: 'H', flipped: 0 },
              { letter: 'H', flipped: 0 }];
    this.shuffle(tiles);
    return tiles;
  }

  //  Everytime a tile is clicked, this function is called.
  // If this is the second tile clicked (the previous tile in the this.state
// is not NULL), then it will call the function determineMatch.
// determineMatch is delayed so that both cards will expose the letters for
// 1 second before hiding them if they both don't match.
  handleClick(i) {
    this.state.attempts++;
    let new_tiles = this.state.tiles;
    new_tiles[i].flipped = 1;
    let new_state = _.extend(this.state, {
      tiles: new_tiles,
    });
    this.setState(new_state);
    setTimeout(function() {
      this.determineMatch(new_tiles[i])
    }.bind(this), 1000);
  }

  // determine if there is a match between two tiles clicked
  // If there is not a match, the flipped parameter of both of the
  // tiles goes back to false (0). If there is a match,
  // both tiles remain flipped.
  determineMatch(currentTile) {
    let last_tile = this.state.last_tile;
    if (this.state.last_tile == null) {
      let new_state_1 = _.extend(this.state, {
        last_tile: currentTile,
      });
      this.setState(new_state_1);
    }
    else {
      if (currentTile.letter != last_tile.letter) {
        currentTile.flipped = 0;
        last_tile.flipped = 0;
      }
      let new_state = {
        tiles: this.state.tiles,
        last_tile : null
      }
      this.setState(new_state);
    }

  }

  // This function is called when the "Reset Game" button is clicked.
  // It sets the state to it's initial_state
  resetGame() {
    let initial_state = {
      tiles : this.initalizeTiles(),
      attempts: 0,
      last_tile: null
    }
    this.setState(initial_state);
  }

  // Renders a Tile from the game's tiles given an index.
  renderTile(i) {
    let tile = this.state.tiles[i];
    return (<Tile letter={tile.letter} flipped={tile.flipped} onClick={() => this.handleClick(i)}/>);
  }

  // Renders the entire game
  render() {
    return(
      <div>
        <div className="row">
          <h1>Memory Game</h1>
          <button id="reset" onClick={() => this.resetGame()}>Reset Game</button>
          <h4 id="score"> Score: {this.state.attempts} </h4>
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
  let tile_id = params.flipped ? "show" : "back-side";
  let content = params.flipped ? params.letter : "?";
  let click = params.flipped ? undefined : params.onClick;
      return (
        <a className="tile" id={tile_id} onClick={click}>
          <p id="tile-content">{content}</p>
        </a>
      );
}
