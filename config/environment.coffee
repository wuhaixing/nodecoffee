module.exports =
  development:
    app:
      name: 'Node社区'
    root: require('path').normalize(__dirname + '/..')
    db: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://localhost/nodecoffee'
