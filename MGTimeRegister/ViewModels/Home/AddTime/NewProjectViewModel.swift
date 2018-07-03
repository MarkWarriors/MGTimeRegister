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
    
    private let privateDismissModal = PublishSubject<(Void)>()
    private let privateCurrentCompany = BehaviorRelay<Company?>(value: nil)
    
    private let privateProjectName = BehaviorRelay<String>(value: "")
    private let privateProjectSelected = PublishRelay<Project>()
    
    
    init(company: Company, onProjectSelected: BehaviorRelay<Project?>) {
        self.privateCurrentCompany.accept(company)
        privateProjectSelected.bind(to: onProjectSelected).disposed(by: disposeBag)
    }
    
    var projectSelected : Observable<Project> {
        return self.privateProjectSelected.asObservable()
    }
    
    var companyNameText : Observable<(String)> {
        return Observable.just(self.privateCurrentCompany.value!.name!)
    }
    
    var dismissModal : Observable<(Void)> {
        return self.privateDismissModal.asObservable()
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
                self?.privateDismissModal.onNext(Void())
            })
            .disposed(by: self.disposeBag)
        
        saveBtnPressed
            .drive(onNext: { [weak self] in
                self?.privateDismissModal.onNext(Void())
                self?.createProject()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createProject(){
        let project = ModelController.shared.new(forEntity: ModelController.Entity.project) as! Project
        project.name = privateProjectName.value
        self.privateCurrentCompany.value!.addToProjects(project)
        ModelController.shared.save()
        self.privateProjectSelected.accept(project)
    }

}
