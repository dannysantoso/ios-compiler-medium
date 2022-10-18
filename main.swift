class Home {
    func people() {
        let bob = Bob()
        bob.walk()

        let john = John()
        john.walk()
    }
}

let home = Home()
home.people()