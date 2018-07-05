//
//  TimeListViewModel.swift
//  
//
//  Created by Marco Guerrieri on 05/07/18.
//

import Foundation
import RxSwift
import RxCocoa

class ReportTimeListViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privatePerformSegue = PublishSubject<(MGTViewModelSegue)>()
    private let privateDataSource = BehaviorRelay<[Time]>(value: [])
    
    private var privateSelectedTime = BehaviorRelay<Time?>(value: nil)
    private let currentProject : Project
    
    var dataSource : Observable<[Time]> {
        return self.privateDataSource.asObservable()
    }
    
    init(project: Project, times: [Time]) {
        self.privateDataSource.accept(times)
        self.currentProject = project
    }
    
    var projectText : Observable<String> {
        return Observable.just("\(currentProject.company!.name!) > \(currentProject.name!)")
    }
    
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    public func initBindings(fetchDataSource: Driver<Void>,
                             selectedItem: Driver<Time>){
        privateSelectedTime
            .filter{ $0 != nil }
            .bind(onNext: { [weak self] (time) in
                self?.privatePerformSegue.onNext(MGTViewModelSegue.init(identifier: Segues.Home.Reports.toTimeDetails))
            })
            .disposed(by: disposeBag)
        
        
        selectedItem
            .drive(onNext: { [weak self] (time) in
            })
            .disposed(by: self.disposeBag)
    }
    
    
    public func viewModelFor(_ vc: inout UIViewController) {
//        if let vc = vc as? NewTimeEntryVC {
//            vc.viewModel = NewTimeEntryViewModel(project: privateSelectedProject.value!)
//        }
//        else if let vc = vc as? NewProjectVC {
//            vc.viewModel = NewProjectViewModel(èroject: privateCurrentProject, onProjectSelected: privateSelectedProject)
//        }
    }
}
