components {
  id: "map_farm"
  component: "/levels/town/outside/map/overworldTiles/map_overworld_tiles.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "overworldTileFactory"
  type: "factory"
  data: "prototype: \"/levels/town/outside/map/overworldTiles/tile/tileOverworld.go\"\n"
  "load_dynamically: false\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
