//
//  SelectVisitTypeView.swift
//
//
//  Created by Parker Erway on 1/22/15.
//
//

import UIKit

protocol SelectVisitTypeViewDelegate
{
    func didSelectVisitType(_ type: MRSVisitType)
}

class SelectVisitTypeView : UITableViewController, UIViewControllerRestoration
{
    var visitTypes: [MRSVisitType]! = []
    var delegate: SelectVisitTypeViewDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override init(style: UITableViewStyle) {
        super.init(style: .plain)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MRSHelperFunctions.updateTableView(forDynamicTypeSize: self.tableView)
    }

    func updateFontSize() {
        MRSHelperFunctions.updateTableView(forDynamicTypeSize: self.tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restorationIdentifier = NSStringFromClass(type(of: self));
        self.restorationClass = type(of: self);

        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector:#selector(SelectVisitTypeView.updateFontSize), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        MRSHelperFunctions.updateTableView(forDynamicTypeSize: self.tableView)

        self.title = NSLocalizedString("Visit Type", comment: "Label -visit- -type-")

        self.reloadData()
    }
    func reloadData()
    {
        if self.visitTypes == nil
        {
            MBProgressExtension.showBlock(withTitle: NSLocalizedString("Loading", comment: "Label loading"), in: self.view)
            OpenMRSAPIManager.getVisitTypes { (error:NSError!, types:[AnyObject]!) -> Void in
                MBProgressExtension.hideActivityIndicator(in: self.view)
                if error != nil
                {
                    MRSAlertHandler.alertViewForError(self, error: error).show();
                    NSLog("Error getting visit types: \(error)")
                }
                else
                {
                    MBProgressExtension.showSucess(withTitle: NSLocalizedString("Completed", comment: "Label completed"), in: self.view)
                    self.visitTypes = types as! [MRSVisitType]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visitTypes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")

        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }

        let visitType = self.visitTypes[indexPath.row]

        cell.textLabel?.text = visitType.display

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visitType = visitTypes[indexPath.row]
        delegate.didSelectVisitType(visitType)
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.delegate as! StartVisitViewController, forKey: "delegate")
        coder.encode(self.visitTypes, forKey: "visitTypes")
    }

    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        let visitTypeList = SelectVisitTypeView(style: UITableViewStyle.plain)
        visitTypeList.visitTypes = coder.decodeObject(forKey: "visitTypes") as! [MRSVisitType]
        visitTypeList.delegate = coder.decodeObject(forKey: "delegate") as! StartVisitViewController
        return visitTypeList
    }
}
