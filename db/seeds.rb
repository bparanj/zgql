me = Person.create(first_name: 'Steven', last_name: 'Luscher', email: 'steveluscher@fb.com', username: 'steveluscher')
dhh = Person.create(first_name: 'David', last_name: 'Heinemeier Hansson', email: 'dhh@37signals.com', username: 'dhh')
ezra = Person.create(first_name: 'Ezra', last_name: 'Zygmuntowicz', email: 'ezra@merbivore.com', username: 'ezra')
matz = Person.create(first_name: 'Yukihiro', last_name: 'Matsumoto', email: 'matz@heroku.com', username: 'matz')
me.friends << [matz]
dhh.friends << [ezra, matz]
ezra.friends << [dhh, matz]
matz.friends << [me, ezra, dhh]
