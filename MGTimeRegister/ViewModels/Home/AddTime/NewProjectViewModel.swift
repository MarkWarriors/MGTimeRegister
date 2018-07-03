//
//  NewProjectViewModel.swift
//  
//
//  Created by Marco Guerrieri on 03/07/18.
//

import UIKit
import RxSwift
import RxCocoa

class NewProjectViewModel: MGTBaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    
    private let privateCloseVC = PublishSubject<(Void)>()
    private let privateProjectName = BehaviorRelay<String>(value: "")
    private let privateProjectSelected = PublishSubject<Project>()
    private let currentCompany : Company
    
    init(company: Company) {
        self.currentCompany = company
    }
    
    var projectSelected : Observable<Project> {
        return self.privateProjectSelected.asObservable()
    }
    
    var companyNameText : Observable<(String)> {
        return Observable.just(self.currentCompany.name!)
    }
    
    var closeVC : Observable<(Void)> {
        return self.privateCloseVC.asObservable()
    }
    
    var buttonEnabled : Observable<Bool> {
        return privateProjectName.map { $0 != "" }.asObservable()
    }
    
    public func initBindings(newProjectName: Observable<String>,
                             saveBtnPressed: Driver<Void>,
                             closeBtnPressed: Driver<Void>) {
        
        newProjectName.bind(to: privateProjectName).disposed(by: disposeBag)
        
        closeBtnPressed
            .drive(onNext: { [weak self] in
                self?.privateCloseVC.onNext(Void())
            })
            .disposed(by: self.disposeBag)
        
        saveBtnPressed
            .drive(onNext: { [weak self] in
                self?.createProject()
                self?.privateCloseVC.onNext(Void())
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createProject(){
        let project = ModelController.shared.new(forEntity: ModelController.Entity.project) as! Project
        project.name = privateProjectName.value
        self.currentCompany.addToProjects(project)
        ModelController.shared.save()
        self.privateProjectSelected.onNext(project)
    }

}
