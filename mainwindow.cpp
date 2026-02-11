#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFile>
#include <QFileDialog>
#include <QTextStream>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
// In MainWindow::MainWindow(QWidget *parent), after ui->setupUi(this);

// Set explicit icons for toolbar actions
ui->actionNew->setIcon(QIcon::fromTheme("document-new"));
ui->actionOpen->setIcon(QIcon::fromTheme("document-open"));
ui->actionSave->setIcon(QIcon::fromTheme("document-save"));
ui->actionSave_As->setIcon(QIcon::fromTheme("document-save-as"));
ui->actionCut->setIcon(QIcon::fromTheme("edit-cut"));
ui->actionCopy->setIcon(QIcon::fromTheme("edit-copy"));
ui->actionPaste->setIcon(QIcon::fromTheme("edit-paste"));
ui->actionUndo->setIcon(QIcon::fromTheme("edit-undo"));
ui->actionRedo->setIcon(QIcon::fromTheme("edit-redo"));
ui->actionAbout->setIcon(QIcon::fromTheme("help-about"));
    //QToolBar *toolbar = addToolBar("Main Toolbar");
    this->setCentralWidget(ui->textEdit);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionNew_triggered()
{
    file_path = "";
    ui->textEdit->setText("");
}


void MainWindow::on_actionOpen_triggered()
{
    QString file_name = QFileDialog::getOpenFileName(this,"Open the file");
    QFile file(file_name);
    file_path = file_name;
    if (!file.open(QFile::ReadOnly | QFile::Text )){
        QMessageBox::warning(this,"..","file not open");
            return;
    }
    QTextStream in(&file);
    QString text = in.readAll();
    ui->textEdit->setText(text);
    file.close();
}


void MainWindow::on_actionSave_triggered()
{

    QFile file(file_path);
    if (!file.open(QFile::WriteOnly | QFile::Text )){
        QMessageBox::warning(this,"..","file not open");
        return;
    }
    QTextStream out(&file);
    QString text = ui->textEdit->toPlainText();
    out<<text;
    file.flush();
    file.close();
}


void MainWindow::on_actionSave_As_triggered()
{
    QString file_name = QFileDialog::getSaveFileName(this,"Open the file");
    QFile file(file_name);
    file_path = file_name;
    if (!file.open(QFile::WriteOnly | QFile::Text )){
        QMessageBox::warning(this,"..","file not open");
        return;
    }
    QTextStream out(&file);
    QString text = ui->textEdit->toPlainText();
    out<<text;
    file.flush();
    file.close();
}


void MainWindow::on_actionCut_triggered()
{
    ui->textEdit->cut();
}


void MainWindow::on_actionCopy_triggered()
{
    ui->textEdit->copy();
}


void MainWindow::on_actionPaste_triggered()
{
    ui->textEdit->paste();
}


void MainWindow::on_actionRedo_triggered()
{
    ui->textEdit->redo();
}


void MainWindow::on_actionUndo_triggered()
{
   // if(ui->textEdit->undoAvailable())
        ui->textEdit->undo();

}


void MainWindow::on_actionAbout_triggered()
{
    QString about_text;
    about_text = "Auther: Michael Ochieng'\n";
    about_text +="Date  : 05/02/2026\n";
    about_text +="(C) NotePied (R)";
    QMessageBox::about(this,"About NotePied",about_text);
}

