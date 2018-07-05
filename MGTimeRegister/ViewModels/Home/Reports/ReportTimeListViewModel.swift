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
    
    init(project: Project, times: [Time]) {
        self.privateDataSource.accept(times)
        self.currentProject = project
    }
    
    var projectText : Observable<String> {
        return Observable.just(currentProject.name!)
    }
    
    var dataSource : Observable<[Time]> {
        return self.privateDataSource.asObservable()
    }
    
    var performSegue : Observable<(MGTViewModelSegue)> {
        return self.privatePerformSegue.asObservable()
    }
    
    public func initBindings(fetchDataSource: Driver<Void>,
                             selectedRow: Driver<IndexPath>){
        privateSelectedTime
            .filter{ $0 != nil }
            .bind(onNext: { [weak self] (time) in
                self?.privatePerformSegue.onNext(MGTViewModelSegue.init(identifier: Segues.Home.Reports.toTimeDetails))
            })
            .disposed(by: disposeBag)
        
        
        selectedRow
            .drive(onNext: { [weak self] (indexPath) in self?.privateSelectedTime.accept((self?.privateDataSource.value[indexPath.row])!)
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
