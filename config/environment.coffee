module.exports =
  development:
    app:
      host: 'localhost:3000'  
      name: 'Node Coffee'
    root: require('path').normalize(__dirname + '/..')
    db: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or 'mongodb://localhost/nodecoffee'
    secret:'p8zztgch48rehu79jskhm6aj3'    
  production:
    app:
      host: 'localhost:3000'  
      name: 'Node Coffee'
    root: require('path').normalize(__dirname + '/..')
    db: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or 'mongodb://localhost/nodecoffee'
    secret:'p8zztgch48rehu79jskhm6aj3'
