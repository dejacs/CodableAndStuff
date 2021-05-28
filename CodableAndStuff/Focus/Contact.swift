//
//  Contact.swift
//  CodableAndStuff
//
//  Created by Jade Silveira on 28/05/21.
//

import Foundation

// -> Quando não amarrar o Response (Decodable) e o Request (Encodable) num só objeto (Codable):
// Ex: Carrega a tela de dados de endereço com o endereço do usuário
// O usuário poderia informar outro endereço em vez do que veio no serviço
// Esse endereço era utilizado APENAS para envio da placa comercial e não para alterar o endereço do usuário

// -> Quando amarrar o Response (Decodable) e o Request (Encodable) num só objeto (Codable):
// Ex: Edição de informações - o objeto que vem do serviço é o mesmo que será enviado (por exemplo, telefone)


/* JSON
 {
    "meta": "abobora",
    "results_contact": {
        "contact1": {
             "firstName": "Claudia",
             "lastName": "Maganhi",
             "age": 1
        },
         "contact2": {
             "firstName": "Jade",
             "lastName": "Silveira",
             "age": 25,
             "email": "janskjdna@jkanskd.com"
         },
    },
    "paging": {
        "numberOfPages": 3,
        "pages": {
            "name": 10,
            "something": 15,
            "another": 13
        }
    }
 }
 */

struct Contact: Decodable {
    let name, email: String // não é necessário criar coding keys porque os atributos são iguais aos do json
}

struct ContactRequest: Encodable {
    let id, name: String // mapeamento somente dos atributos ou objetos que de fato serão utilizados no código
    let age: Int
    
    enum Chaves: String, CodingKey { // Associação com o que vem do json
        case idLalala, name, idade
    }
    
    func encode(to encoder: Encoder) throws {
        let container = try encoder.container(keyedBy: Chaves.self)
        
    }
}

struct PagesResponse: Decodable {
    let name, something, another: String
    
    enum Chaves: String, CodingKey {
        case name, something, another, pages, paging
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Chaves.self)
        let paging = try container.nestedContainer(keyedBy: Chaves.self, forKey: .paging)
        let pages = try paging.nestedContainer(keyedBy: Chaves.self, forKey: .pages)
        
        name = try pages.decode(String.self, forKey: .name)
        something = try pages.decode(String.self, forKey: .something)
        another = try pages.decode(String.self, forKey: .another)
    }
}

struct ContactResponse: Decodable {
    let name: String
    let idade: Int
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, age, email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        name = "\(firstName) \(lastName)"
        
        idade = try container.decode(Int.self, forKey: .age)
        email = try container.decodeIfPresent(String.self, forKey: .email)
    }
}

struct ContactListResponse: Decodable {
    let contactList: [ContactResponse]
    
    enum CodingKeys: String, CodingKey {
        case results = "results_contact" // caso o nome do campo no json seja diferente
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contactList = try container.decode([ContactResponse].self, forKey: .results)
    }
}
