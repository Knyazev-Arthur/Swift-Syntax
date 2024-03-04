class Human { /// объявление базового класса для предоставления дочерним свойства name
	var name: String
	init(name: String) {
		self.name = name
	}
}


class Father: Human {
	var mother: Mother?
	var kids: [Kids]?
	
	init(name: String, mother: Mother) {
		self.mother = mother
		super.init(name: name)
	}
	
	override init(name: String) { /// переопределяем инициализатор родительского класса для инициализации только имени
		super.init(name: name)
	}
	
	lazy var printFamily = {
		[unowned self] in
		print(self.name)
		print(self.mother!.name)
		self.kids!.map { print($0.name) } /// использование опции map, использующей замыкание
	}
	
	lazy var printMather = { /// ленивое свойство
		[unowned self] in /// объявление листа захвата со слабой ссылкой на собственные характеристики
		print(self.mother!.name)
	}
	
	lazy var printKids = {
		[unowned self] in
		self.kids!.map { print($0.name)
		}
	}
	
	deinit { print("\(name) деинициализирован") }
}


class Mother: Human {
	weak var father: Father? /// слабая ссылка на экземпляр класса для своевременной деинициализации объекта
	var kids: [Kids]?
	
	deinit { print("\(name) деинициализирован") }
}


class Kids: Human {
	unowned var mother: Mother /// бесхозная ссылка на экземляр класса для работы с ним в собственных методах
	unowned var father: Father
	
	init(name: String, mother: Mother, father: Father) {
		self.mother = mother
		self.father = father
		super.init(name: name)
	}
	
	func talkMother() { print("Привет \(mother.name)!") }
	
	func talkFather() { print("Привет \(father.name)!") }
	
	func talkKids(children: Kids) {
		print("Привет \(children.name)!")
	}
	
	deinit { print("\(name) деинициализирован") }
}



class Family {
	var father: Father?
	var mother: Mother?
	var kids: [Kids]?
	
	init(father: Father, mother: Mother, kids: Kids...) {
		self.father = father
		self.mother = mother
		self.kids = kids
		
		father.mother = mother
		mother.father = father
		mother.kids = self.kids
		father.kids = self.kids
	}
}

if true {
	let father = Father(name: "Папа")
	let mother = Mother(name: "Мама")
	let kids1 = Kids(name: "Кидас 1", mother: mother, father: father)
	let kids2 = Kids(name: "Кидас 2", mother: mother, father: father)
	Family(father: father, mother: mother, kids: kids1, kids2)
	
	father.printFamily()
	father.printKids()
	father.printMather()
	
	kids1.talkFather()
	kids1.talkKids(children: kids2)
	kids1.talkMother()
}
