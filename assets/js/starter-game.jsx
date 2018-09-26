import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root) {
  ReactDOM.render(<MatchingBoard />, root);
}

class MatchingBoard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      matches : 0,
      tiles : this.initalizeTiles(),
      attempts: 0,
      last_tile: null // keeps track of the last tile clicked
    };
  }

shuffle(tiles) {
    for (let i = tiles.length - 1; i>=0; i--) {
      let random_index = Math.floor(Math.random() * (i + 1));
      let item = tiles[random_index];
      tiles[random_index] = tiles[i];
      tiles[i] = item;
    }
  }

  // shuffle cards at the start of the game
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
              { letter: 'H', flipped: 0 }]
    this.shuffle(tiles);
    return tiles;
  }

  handleClick(i) {
    let new_tiles = this.state.tiles;
    new_tiles[i].flipped = 1;
    let new_state = _.extend(this.state, {
      tiles: new_tiles,
    });
    this.setState(new_state);
    console.log(this.state.last_tile);
    setTimeout(function() {
      this.determineMatch(new_tiles[i])
    }.bind(this), 1000);
  }

  // determine if there is a match between two tiles clicked
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


  renderTile(i) {
    let tile = this.state.tiles[i];
    return (<Tile letter={tile.letter} flipped={tile.flipped} onClick={() => this.handleClick(i)}/>);
  }

  render() {
    return(
      <div>
        <div>
          <h1>Memory Game</h1>
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

function Tile(params) {
  let tile_id = params.flipped ? "show" : "back-side";
  let content = params.flipped ? params.letter : "?";
  let click = params.flipped ? "" : params.onClick;
      return (
        <a className="tile" id={tile_id} onClick={click}>
          {content}
        </a>
      );
}
