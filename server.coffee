config          = require  './config.js'
express         = require 'express'
path            = require 'path'
app             = express()
server          = require('http').Server(app);
bodyParser      = require 'body-parser'
logger          = require 'express-logger'
fs              = require 'fs'
PusherClient    = require('pusher-node-client').PusherClient
request         = require 'request-json'
_               = require 'lodash'
sigma           = require 'compute-stdev'

delay = (t, cb) -> setTimeout cb, t
repeatedly = (interval, cb) -> setInterval cb, interval

# 
# http part
#
# express config
port = 3000
publicDir = "#{__dirname}/dist"
app.use(express.static(publicDir))
app.use(bodyParser.json())
# debug logger
app.use(logger({path: './logs/logfile.txt'}))

# ship webapp on /
read =  (file) -> fs.createReadStream(path.join(publicDir, file))
app.get '/', (req, res) -> read('index.html').pipe(res)

# run server
server.listen(port)
console.log 'server listening on ' + port

#
# pusher part
#
# pusher config
pusherClient = new PusherClient
    appId: config.PUSHER_APP_ID
    key: config.PUSHER_KEY
    secret: config.PUSHER_SECRET
    encrypted: config.IS_PUSHER_ENCRYPTED

client = request.createClient 'http://indra.webfactional.com/' 
handlePostErrors = (err, res, body) -> if err then console.log 'err!', err
publish = (r) -> client.post '/', r, handlePostErrors

cars = {}
moveCar = (color, amplitude) ->
    car = cars[color] 
    if not car
        cars[color] = {color: color, position: 0}
    if car
        car.position += amplitude/10
        cars[color] = car
    return cars[color]

checkForWinner = (car) ->
    # if the max car position > 1000, we have a winner!
    furthestCar = _.max cars, 'position'
    if furthestCar.position > 100 then return furthestCar
    return null

game = 'on'
# listen for microphone amplitude data
pusherClient.on 'connect', () ->
    sub = pusherClient.subscribe 'everything'
    # whenever a microphone amplitude comes in,
    # compute the car's position + send it back out as carPosition
    sub.on 'racerMicAmp', (d) ->
        if game is 'on'
            cars[d.color] = moveCar d.color, d.amplitude 
            publish _.extend cars, {type: 'carPosition'}
            # check for a winner
            winner = checkForWinner cars
            if winner 
                publish { type:'winner', winner: winner }
                cars = {}
                game = 'over'

# connect to pusher
pusherClient.connect()

