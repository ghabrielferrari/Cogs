//
//  CoreData.swift
//  Cogs
//
//  Created by Aluno 11 on 28/05/25.
//

import CoreData

// estrutura que define, configura e gerencia o Core Data Stack
struct PersistenceController{
    // cria instancia compartilhada (singleton) garantindo que haja apenas um controlador de persistencia no app
    // static let = faz shared ser acessivel globalmente sem ter que ficar chamando
    static let shared = PersistenceController()
    
    // define container que é NSpersistentcontainer, objeto PRINCIPAL Core Data
    // gerencia modelo de dados, armazenamento persistente e o contexto do Core Data
    let container : NSPersistentContainer
    
    // inicializa a estrutura, com um parametro opcional inMemory (padrão: false)
    // inMemory permite criar banco de dados temporario na memoria (Bom pra testes)
    init(inMemory: Bool = false){
        
        // inicializa NSpersistence com o nome do modelo de dados (CogsData)
        container = NSPersistentContainer(name: "CogsData")
        
        // se inmemory = true, configura ambiente temporario (/dev/null)
        // nao salva os dados em disco, descartados quando o app for encerrado
        if inMemory{
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // carrega lojas persistentes (conecta o modelo de dados ao BD fisico)
        container.loadPersistentStores(completionHandler: {(StoreDescription, error) in
            // verifica se houve erros ao conectar BD
            if let error = error as NSError? {
                // em caso de erro, interrompe a execucao e mostra onde esta o erro
                // tratar de forma mais amigavel em um app real
                fatalError("Unresolved Error \(error), \(error.userInfo)")
            }
        })
        
        // config viewContext para mesclagem automatica mudancas de contextos secundarios (segundo plano...)
        // util para appps com múltiplos contextos ou sincronizações em segundo plano
        container.viewContext.automaticallyMergesChangesFromParent = true
        
    }
}
