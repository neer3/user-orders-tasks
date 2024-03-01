import React, { useState, useEffect } from 'react';
import DataGrid, { Column, Export } from 'devextreme-react/data-grid';
import { exportDataGrid } from 'devextreme/excel_exporter';
import { Workbook } from 'exceljs';
import saveAs from 'file-saver';
import 'devextreme/dist/css/dx.common.css';
import 'devextreme/dist/css/dx.light.css';

const OrderHistories = () => {
  const [data, setData] = useState([]);
  const [exportStatus, setExportStatus] = useState(null);

    useEffect(() => {
        fetch('http://localhost:3000/order_histories') // Replace with your API endpoint
        .then(response => response.json())
        .then(data => setData(data["data"]));
    }, []);

    function exportGrid(e) {
        const workbook = new Workbook(); 
        const worksheet = workbook.addWorksheet("Main sheet"); 
        exportDataGrid({ 
            worksheet: worksheet, 
            component: e.component,
        }).then(function() {
            workbook.xlsx.writeBuffer().then(function(buffer) { 
                saveAs(new Blob([buffer], { type: "application/octet-stream" }), "OrderHistories.xlsx"); 
            }); 
        });
    }

    const handleExportClick = (userId, userName) => {
        setExportStatus('initiating');
    
        fetch(`http://localhost:3000/order_histories/export/${userId}`, {
          method: 'GET',
        })
        .then(response => response.json())
        .then(result => {
        setExportStatus('initiated');
        alert(result.message);

        const checkExportStatus = setInterval(() => {
            fetch(`http://localhost:3000/order_histories/export_status/${userId}`)
            .then(response => response.json())
            .then(statusResult => {
                if (statusResult.status === 'completed') {
                    setExportStatus('completed');
                    var downloadLink = `http://localhost:3000/${statusResult.file_path}`;
                    clearInterval(checkExportStatus);
                    triggerDownload(userName, downloadLink);
                } else if (statusResult.status === 'failed') {
                    setExportStatus('failed');
                    clearInterval(checkExportStatus);
                }
            })
            .catch(error => {
                console.error('Error checking export status:', error);
                clearInterval(checkExportStatus);
            });
        }, 5000);
        })
        .catch(error => {
            setExportStatus('failed');
            console.error('Error exporting order history:', error);
        });
    };

    const triggerDownload = (userName, downloadLink) => {
        if (downloadLink && downloadLink.length > 1) {
            const anchor = document.createElement('a');
            anchor.href = downloadLink;
            anchor.download = `${userName}.csv`;
            anchor.click();
        }
    };

    return (
        <DataGrid
        dataSource={data}
        onExporting={exportGrid}
        showBorders={true}
        keyExpr="username"
        >
        <Column dataField="username" caption="Username" />
        <Column dataField="email" caption="Email" />
        <Column
            allowExporting={false}
            caption="Download Order Histories"
            cellRender={(rowData) => (
            <button
                onClick={() => handleExportClick(rowData.data.id, rowData.data.username)}
                disabled={exportStatus === 'initiating' || exportStatus === 'initiated'}
              >
                Export
              </button>
            )}
        />
        <Export enabled={true} />
        </DataGrid>
    );
};

export default OrderHistories;
