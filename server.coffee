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
postReading = (r) -> client.post '/', r, handlePostErrors
# listen for microphone amplitude data
pusherClient.on 'connect', () ->
    sub = pusherClient.subscribe 'everything'
    # whenever a microphone amplitude comes in,
    # send it to everyone
    sub.on 'microphoneAmplitude', (d) ->
        d.type = 'carDelta'
        postReading d

# connect to pusher
pusherClient.connect()

