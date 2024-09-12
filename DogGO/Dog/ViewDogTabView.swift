import SwiftUI
import CoreData

struct ViewDogTabView: View {
    @EnvironmentObject var scheduleDataStore: ScheduleDataStore
    @EnvironmentObject var dogDataStore: DogDataStore
    @EnvironmentObject var vetInformationDataStore: VetInformationDataStore
    
    var dog: Dog
    var vet: VetInformation
    
    var body: some View {
        TabView {
            ViewDogInformationView(dog: dog)
                .tabItem {
                    Label("Info", systemImage: "dog")
                }
            
            ViewScheduleView(dog: dog)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            
            ContactView(dog: dog)  
                .tabItem {
                    Label("Contact", systemImage: "phone.bubble")
                }
        }
        .onAppear {
            guard let dogID = dog.dogID else {
                print("Dog ID is nil, cannot fetch schedules")
                return
            }
            scheduleDataStore.fetchSchedules(for: dogID)
        }

    }
}


#Preview {
    let managedObjectContext = CoreDataStack.shared.context
    let sampleDog = Dog(context: managedObjectContext)
    sampleDog.name = "Buddy"
    
    let sampleVet = VetInformation(context: managedObjectContext)
    
    return ViewDogTabView(dog: sampleDog, vet: sampleVet)
        .environment(\.managedObjectContext, managedObjectContext)
        .environmentObject(ScheduleDataStore(managedObjectContext: managedObjectContext))
        .environmentObject(DogDataStore(managedObjectContext: managedObjectContext))
        .environmentObject(VetInformationDataStore(managedObjectContext: managedObjectContext))
}
