# Server

> Server for icarus.

## Build & Run

Make sure you are in the `/server` directory. Then, run `npm install` to download the latest node dependencies. To run the server, just run `node server.js`. Make sure you have set up the database and imported the latest data. Check out the [data README file](https://github.com/flytenow/icarus/blob/master/data/README.md) to see how to do this. 

## API Documentation

### `/query`

#### Parameters

| Node | Type | Description |
| --- | --- | --- |
| None | --- | --- |

#### Returns

| Node | Type | Description |
| --- | --- | --- |
| `activeRows` | `int` | The number of events that are being used to calculate totals for the graph. |
| `maxRows` | `int` | The total number of events in the database. |
| `years` | `array<year>` | An array of `year` objects that contains totals for each year. |

##### `year` Object

| Node | Type | Description |
| --- | --- | --- |
| `year` | `string` | A string representation of the year. |
| `events` | `int` | The total number of applicable events that occurred in the given year. |
| `fatalities` | `int` | The total number of fatalities from applicable events that occurred in the given year. |
| `injuries` | `int` | The total number of injuries from applicable events that occurred in the given year. |
